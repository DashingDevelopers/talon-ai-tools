# Ask a question in the voice command and the AI will answer it.
model ask <user.text>$:
    result = user.gpt_answer_question(text)
    user.paste(result)

# Runs a model prompt on the selected text and pastes the result.
model {user.staticPrompt} [this]$:
    text = edit.selected_text()
    result = user.gpt_apply_prompt(user.staticPrompt, text)
    user.paste(result)

# Runs a model prompt on the selected text and sets the result to the clipboard
model clip {user.staticPrompt} [this]$:
    text = edit.selected_text()
    result = user.gpt_apply_prompt(user.staticPrompt, text)
    clip.set_text(result)

# Say your prompt directly and the AI will apply it to the selected text
model please <user.text>$:
    prompt = user.text
    txt = edit.selected_text()
    result = user.gpt_apply_prompt(prompt, txt)
    user.paste(result)

# Applies an arbitrary prompt from the clipboard to selected text and pastes the result.
# Useful for applying complex/custom prompts that need to be drafted in a text editor.
model apply [from] clip$:
    prompt = clip.text()
    text = edit.selected_text()
    result = user.gpt_apply_prompt(prompt, text)
    user.paste(result)

# Shows the list of available prompts
model help$: user.gpt_help()

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
