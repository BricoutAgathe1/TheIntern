# ============================================
# Test generator
# ============================================

$docsPath = "C:\Users\agath\code-doc-assistant\Test_gen"
$docTemplatePath = "$docsPath\test_gen.txt"
$ollamaModel = "llama3"
$testName = "In Device management module, Operational status design"

# Load template
$docTemplate = Get-Content -Raw $docTemplatePath

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

# ---------- START TIMER ----------
$startTime = Get-Date

Write-Host "Generating test..." -ForegroundColor Yellow

# Replace variable in template
$prompt = $docTemplate -replace '{{TESTNAME}}', $testName

# Save prompt to temp file
$promptFile = "$env:TEMP\ollama_test_prompt.txt"
$prompt | Out-File -FilePath $promptFile -Encoding utf8

# Generate test
$GeneratedTest = Get-Content $promptFile | ollama run $ollamaModel

# Save output
$outFile = "$docsPath\test.feature"
$GeneratedTest | Out-File $outFile -Encoding utf8

Write-Host "`nGenerated test saved to: $outFile" -ForegroundColor Green

# ---------- END TIMER ----------
$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "`nTotal runtime: $($duration.Hours)h $($duration.Minutes)m $($duration.Seconds)s" -ForegroundColor Cyan
