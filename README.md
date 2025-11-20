# TheIntern
Locally-hosted AI assistant generating code documentation. Safe for commercial use when use of cloud-based AI is forbidden for data security reasons.  

**Input:** Coding project directory  
**Output:** Generates project-wide documentation in an .md file than can be converted to .docx using Pandoc

## How to use
### Requirements
- Windows 10 or 11
- Powershell (Default on Windows 10/11)
- Ollama (Download from: https://ollama.com/download/windows)
- _Optional:_ Pandoc (Download from: https://pandoc.org/installing.html) if wanting .docx conversion
You only need to download Ollama and Pandoc once prior to running TheIntern. Powershell should already be installed.

### Files
- **docgen.txt:** Prompt to be fed to the chosen model in _generate-docs-context.ps1_. Modify as needed.
- **generate-docs-context.ps1:** Powershell script used to launch TheIntern. Possibility to modify the AI model needed, need to change the paths to point to the correct directories.

With the requirements met and the paths in _generate-docs-context.ps1_ pointing to the correct directories, start TheIntern by running `.\generate-docs-context.ps1` from your computer's terminal using Powershell.
If needing to convert to .docx, with Pandoc installed run `pandoc project_doc.md -o project_doc.docx `.


## Gherkin test generator: TheIntern's other job
- **test_gen.txt**: Prompt to be fed to the chosen model in _test_generator.ps1_. Modify as needed.
- **test_generator.ps1**: Powershell script used to generate Gherkin tests. Possibility to modify AI model needed, need to change the test name before running through `.\test_generator.ps1` from your computer's terminal.

# About
Created by Agathe Bricout [University of Edinburgh] for IMV Imaging, Angouleme.
