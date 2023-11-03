# Prerequisites

1. Install the [Microsoft Visual C++ Redistributable for Visual Studio 2019](https://support.microsoft.com/help/2977003/the-latest-supported-visual-c-downloads) for your platform.
2. Install [.NET 6](https://learn.microsoft.com/en-us/dotnet/core/install/windows?tabs=net60#runtime-information).
3. Install the Speech CLI via the .NET CLI by entering this command:
```
dotnet tool install --global Microsoft.CognitiveServices.Speech.CLI
```
To update the Speech CLI, enter this command:
```
dotnet tool update --global Microsoft.CognitiveServices.Speech.CLI
```

## Create a resource configuration

To configure your resource key and region identifier, run the following commands:
```
spx config @key --set SPEECH-KEY
spx config @region --set SPEECH-REGION
```

To configure your Speech resource key and region identifier in PowerShell, run the following commands instead:
```
spx --% config @key --set SPEECH-KEY
spx --% config @region --set SPEECH-REGION
```

# Speech CLI Usage

## Speech to text (speech recognition)
To convert speech to text (speech recognition) by using your system's default microphone, run the following command:
```
spx recognize --microphone
```
After you run the command, SPX begins listening for audio on the current active input device. It stops listening when you select Enter. The spoken audio is then recognized and converted to text in the console output.

With the Speech CLI, you can also recognize speech from an audio file. Run the following command:
```
spx recognize --file /path/to/file.wav
```

## Text to speech (speech synthesis)

The following command takes text as input and then outputs the synthesized speech to the current active output device (for example, your computer speakers).
```
spx synthesize --text "Testing synthesis using the Speech CLI" --speakers
```

You can also save the synthesized output to a file. In this example, let's create a file named my-sample.wav in the directory where you're running the command.
```
spx synthesize --text "Enjoy using the Speech CLI." --audio output my-sample.wav
```

## Speech Synthesis Markup Language (SSML)

Speech Synthesis Markup Language (SSML) is an XML-based markup language that you can use to fine-tune your text to speech output attributes such as pitch, pronunciation, speaking rate, volume, and more. It gives you more control and flexibility than plain text input. For example:

```xml
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="https://www.w3.org/2001/mstts" xml:lang="en-US">
    <voice name="en-US-JennyNeural">
        <mstts:express-as style="sad">
            You can use Speech Synthesis Markup Language to specify the text to speech voice, language, name, style, and role for your speech output.
        </mstts:express-as>
        <mstts:express-as style="whispering">
            You can use Speech Synthesis Markup Language to specify the text to speech voice, language, name, style, and role for your speech output.
        </mstts:express-as>
    </voice>
    <voice name="en-US-JennyNeural" effect="eq_car">
        You can use Speech Synthesis Markup Language to specify the text to speech voice, language, name, style, and role for your speech output.
    </voice>
</speak>
```

```
spx synthesize --file speech.ssml --speakers
```

## Translate speech

Run the following command to translate speech from the microphone from English to Italian:
```
spx translate --source en-US --target it --microphone
```
Speak into the microphone, and you see the transcription of your translated speech in real-time. The Speech CLI stops after a period of silence, 30 seconds, or when you press Ctrl+C.

To get speech from an audio file, use --file instead of --microphone. For compressed audio files such as MP4, install GStreamer and use --format. For more information, see [How to use compressed input audio](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/how-to-use-codec-compressed-audio-input-streams).
```
spx translate --source en-US --target it --file YourAudioFile.wav
spx translate --source en-US --target it --file YourAudioFile.mp4 --format any
```
To change the speech recognition language, replace en-US with another [supported language](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/language-support?tabs=stt#supported-languages). Specify the full locale with a dash (-) separator. For example, es-ES for Spanish (Spain). The default language is en-US if you don't specify a language.



## Batch speech to text (speech recognition)

The Speech service is often used to recognize speech from audio files. In this example, you'll learn how to iterate over a directory using the Speech CLI to capture the recognition output for each .wav file. The --files flag is used to point at the directory where audio files are stored, and the wildcard *.wav is used to tell the Speech CLI to run recognition on every file with the extension .wav. The output for each recognition file is written as a tab separated value in speech_output.tsv.
```
spx recognize --files C:\your_wav_file_dir\*.wav --output file C:\output_dir\speech_output.tsv --threads 10
```

## Get speech recognition results

```
spx recognize --file speechService.wav --output all text --output all file type json

spx recognize --file speechService.wav --output all text --output all file MyRecognition.json

spx recognize --file caption.this.mp4 --format any --output each file - @output.each.detailed
```

# Azure Open AI REST API Usage from PowerShell

```powershell
$resourceName = "YOUR_OPENAI_RESOURCE_NAME"
$deploymentName = "YOUR_OPENAI_DEPLOYMENT_NAME"
$OAI_URL = "https://$resourceName.openai.azure.com/openai/deployments/$deploymentName/completions?api-version=2023-05-15"

$speechResponse = Get-Content -Path PATH_TO_JSON_FILE -Raw
$speechText = (ConvertFrom-Json -InputObject $speechResponse ).'recognizer.recognized.result.text'

$HEADERS = @{
    'api-key' = "YOUR_OPENAI_KEY"
    'Content-Type' = "application/json"
}

$BODY = @{
    prompt = ('Summarize in one sentence - "{0}"' -f $speechText)
}

$oaiResponse = Invoke-RestMethod -Method Post -Uri $OAI_URL -Headers $HEADERS -Body ($BODY|ConvertTo-Json)
$oaiResponse.choices[0].text

```