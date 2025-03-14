import s3fs
import yaml
from PIL import Image
import io
import os
from loguru import logger

# Initialize S3 filesystem
fs = s3fs.S3FileSystem(endpoint_url="https://minio.lab.sspcloud.fr")

def get_s3_path(url: str) -> str:
    """
    Convert MinIO URL to S3 path.
    """
    return url.replace("https://minio.lab.sspcloud.fr/", "s3://")

def get_minio_url(s3_path: str) -> str:
    """
    Convert S3 path back to MinIO URL.
    """
    return s3_path.replace("s3://", "https://minio.lab.sspcloud.fr/")

def get_compressed_filename(s3_path: str) -> str:
    """
    Generate a new filename by adding '_compressed' before the extension.
    """
    base, ext = os.path.splitext(s3_path)
    return f"{base}_compressed{ext}"

def read_image_from_s3(url: str) -> Image.Image:
    """
    Read an image from S3 using fs.open().
    """
    s3_path = get_s3_path(url)

    logger.info(f"Reading image from S3: {s3_path}")

    try:
        with fs.open(s3_path, "rb") as file:
            image = Image.open(file)
            image.load()  # Ensure the image is fully loaded
            return image
    except Exception as e:
        logger.error(f"Failed to read image: {s3_path} - {e}")
        return None

def compress_image(image: Image.Image, quality: int = 50) -> io.BytesIO:
    """
    Compress the image by reducing quality and return it as a BytesIO object.
    """
    logger.info(f"Compressing image with quality: {quality}")

    compressed_image = io.BytesIO()
    image.save(compressed_image, format="JPEG", quality=quality)
    compressed_image.seek(0)  # Reset the stream position
    return compressed_image

def compress_and_upload_image(url: str, quality: int = 50):
    """
    Compress an image and upload it back to MinIO with '_compressed' suffix.
    """
    s3_path = get_s3_path(url)
    compressed_s3_path = get_compressed_filename(s3_path)

    logger.info(f"Generated compressed filename: {compressed_s3_path}")

    # Read image
    img = read_image_from_s3(url)
    if img is None:
        return

    # Compress image
    compressed_img = compress_image(img, quality)

    # Upload back to MinIO
    try:
        with fs.open(compressed_s3_path, "wb") as file:
            file.write(compressed_img.getvalue())

        # Convert back to MinIO URL for easy checking
        minio_url = get_minio_url(compressed_s3_path)
        logger.success(f"Compressed image available at: {minio_url}")
    except Exception as e:
        logger.error(f"Failed to upload compressed image: {compressed_s3_path} - {e}")

def process_all_images(yaml_file: str):
    """
    Read all image URLs from YAML file, compress and upload them.
    """
    logger.info(f"Loading image URLs from {yaml_file}")

    try:
        with open(yaml_file, "r") as file:
            data = yaml.safe_load(file)
            image_urls = data.get("images", [])
    except Exception as e:
        logger.error(f"Failed to read YAML file: {e}")
        return

    if not image_urls:
        logger.warning("No images found in YAML file.")
        return

    logger.info(f"Found {len(image_urls)} images. Starting compression...")

    for url in image_urls:
        compress_and_upload_image(url)

    logger.success("All images processed successfully!")


yaml_file = "./dev-scripts/images.yaml"  # Update with your actual YAML file path
process_all_images(yaml_file)
