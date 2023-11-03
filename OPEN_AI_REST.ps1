$resourceName = "YOUR_OPENAI_RESOURCE_NAME"
$deploymentName = "YOUR_OPENAI_DEPLOYMENT_NAME"

$OAI_URL = "https://$resourceName.openai.azure.com/openai/deployments/$deploymentName/completions?api-version=2023-05-15"

$speechResponse = Get-Content -Path -Path PATH_TO_JSON_FILE -Raw
$speechText = (ConvertFrom-Json -InputObject $speechResponse ).'recognizer.recognized.result.text'

$HEADERS = @{
    'api-key' = "YOUR_OPENAI_KEY"
    'Content-Type' = "application/json"
}

$BODY = @{
    prompt = ('Summarize in one sentence - "{0}"' -f $speechText)
    max_tokens = 250
}

$response = Invoke-RestMethod -Method Post -Uri $OAI_URL -Headers $HEADERS -Body ($BODY|ConvertTo-Json)
$oaiResponse.choices[0].text