# Shows the list of available prompts
model help$: user.gpt_help()

# Runs a model prompt on the selected text; inserts with paste by default
#   Example: `model fix grammar below` -> Fixes the grammar of the selected text and pastes below
#   Example: `model explain this` -> Explains the selected text and pastes in place
#   Example: `model fix grammar clip to browser` -> Fixes the grammar of the text on the clipboard and opens in browser`
model <user.modelPrompt> [{user.modelSource}] [{user.modelDestination}]:
    text = user.gpt_get_source_text(modelSource or "")
    result = user.gpt_apply_prompt(modelPrompt, text)
    user.gpt_insert_response(result, modelDestination or "")

# Select the last GPT response so you can edit it further
model take response: user.gpt_select_last()

# Applies an arbitrary prompt from the clipboard to selected text and pastes the result.
# Useful for applying complex/custom prompts that need to be drafted in a text editor.
model apply [from] clip$:
    prompt = clip.text()
    text = edit.selected_text()
    result = user.gpt_apply_prompt(prompt, text)
    user.paste(result)

# Reformat the last dictation with additional context or formatting instructions
model [nope] that was <user.text>$:
    result = user.gpt_reformat_last(text)
    user.paste(result)

model replace as in <user.text>$:
    preprompt = "Your job is to Fix the following text.  Do not change the original structure of the text. There is a word in the following content that has been mispronounced. Please replace the incorrect homophone based on this description:"
    prompt = user.text
    postprompt = ". The content is"
    txt = edit.selected_text()
    result = user.gpt_apply_prompt("{preprompt} {prompt} {postprompt}", txt)
    user.paste(result)

model replace with <user.text>$:
    preprompt = "Your job is to Fix incorrect homophones that has been mispronounced.  The incorrect homophones is/are"
    prompt = edit.selected_text()
    postprompt = "Please return the correct homophone based on the following description "
    result = user.gpt_apply_prompt("{preprompt} {prompt} {postprompt}", user.text)
    user.paste(result)
