-- file: add-dollar-sign.lua

function CodeBlock(block)
    -- Check if the code block is of type 'bash'
    if block.classes[1] == 'bash' then
      -- Add or replace the 'filename' attribute
      block.attributes['filename'] = 'terminal'
  
      -- Existing code to prepend $ and handle the 'env' attribute...
      local prefix = "$ "
      if block.attributes['env'] then
        prefix = "(" .. block.attributes['env'] .. ") " .. prefix
      end
  
      if block.attributes['no-prefix'] == 'true' then
        prefix = ""
      end
  
      local lines = {}
      for line in block.text:gmatch("[^\r\n]+") do
        table.insert(lines, prefix .. line)
      end
  
      block.text = table.concat(lines, "\n")
    end
    return block
  end