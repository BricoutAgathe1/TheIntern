# ============================================
# Context-Aware AI Code Documentation Generator
# Windows-safe version
# ============================================

$projectPath = "C:\Users\agath\code-doc-assistant\Projet_filter_file" # <-- Change here to your code project directory
$docsPath = "$projectPath\docs" # Output directory of the documentation files
$docTemplatePath = "C:\Users\agath\code-doc-assistant\docgen.txt" # <-- Change here to your docgen.txt directory
$ollamaModel = "llama3"   # <-- Change here to use different model

if (!(Test-Path $docsPath)) {
    New-Item -ItemType Directory -Path $docsPath | Out-Null
}

# ---------- CHECK & INSTALL MODEL ----------
Write-Host "Checking for model: $ollamaModel ..." -ForegroundColor Yellow

$models = ollama list | Select-String -Pattern $ollamaModel

if (!$models) {
    Write-Host "Model not found. Installing..." -ForegroundColor Cyan
    ollama pull $ollamaModel
    Write-Host "Model installed successfully." -ForegroundColor Green
} else {
    Write-Host "Model is already installed." -ForegroundColor Green
}

$promptTemplate = Get-Content $docTemplatePath -Raw
$extensions = @("*.py","*.ps1","*.reg","*.js","*.m","*.jsx","*.ts","*.cpp","*.h","*.java","*.cs","*.html","*.css", "*.txt", "*.bat", "*.log", "*.xlsx", "*.csv") # <-- Add extensions as needed

# ---------- START TIMER ----------
$startTime = Get-Date

# ---------- BUILDING PROJECT-WIDE SUMMARY ----------
Write-Host "Building project-wide documentation..." -ForegroundColor Yellow

$allCode = ""
Get-ChildItem -Path $projectPath -Recurse -Include $extensions | ForEach-Object {
    $filename = $_.Name
	$lang = $_.Extension.TrimStart(".")
    $content  = Get-Content $_.FullName -Raw
    $allCode += "`n`n### File: $filename`n- Language: $lang`n$content"
}

$fullPrompt = @"
You are a professional software documentation assistant.
Generate clear, accurate, and structured documentation for source code files in a multi-language codebase. Do not hallucinate.
Be aware some of the coding comments are in French.

### Strictly obey the following instructions:
1. Describe in details the purpose and structure of each file.
2. Explain in details how each file fits into the overall project.
3. Explain what the overall project does precisely.
4. Explain and document all functions, classes, constants, and important variables.
5. Show interactions between modules.
6. Provide guidelines on how to use the project.
7. Format in **Markdown**.
8. Create two identical versions: first in English, then in French without using the accents.


If the file is a configuration, script, or markup file (YAML, JSON, HTML, etc.), describe its structure and purpose clearly.

Codebase:
$allCode
"@

$promptFile = "$env:TEMP\ollama_full_project_prompt.txt"
$fullPrompt | Out-File $promptFile -Encoding utf8

$fullDoc = Get-Content $promptFile | ollama run $ollamaModel

# Saving final documentation to a Markdown file
$outFile = "$docsPath\project_doc.md"
$fullDoc | Out-File $outFile -Encoding utf8

Write-Host "`nFull project documentation saved to: $outFile" -ForegroundColor Green

# ---------- END TIMER ----------
$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "`nTotal runtime: $($duration.Hours)h $($duration.Minutes)m $($duration.Seconds)s" -ForegroundColor Cyan