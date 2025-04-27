Class ENCODER.Oliver.Ollama Extends %RegisteredObject
{

ClassMethod DownloadModel() As %String [ Language = python ]
{
    import sentence_transformers

    model = sentence_transformers.SentenceTransformer('FremyCompany/BioLORD-2023-M')
    model.save('/iris-shared/model/')
    return "Downloaded"
}

ClassMethod GetEncoding(sentence As %String) As %String [ Language = python ]
{
    import sentence_transformers
    # create the model and form the embeddings
    model = sentence_transformers.SentenceTransformer('/iris-shared/model/')
    embeddings = model.encode(sentence, normalize_embeddings=True).tolist() # Convert search phrase into a vector
    # convert the embeddings to a string
    return str(embeddings)
}

ClassMethod Test(text As %String = "") [ Language = python ]
{
    import sentence_transformers
    import iris
    import requests

    try:
        url = "http://ollama:11434/api/generate"
        data = {
            "model": "llama3.2",
            "prompt": "Who was the 46th president of the United States of America?"+text,
            "stream": False
        }
        response = requests.post(url, json=data)
        analyzedText = response.json()
        
        model = sentence_transformers.SentenceTransformer('/iris-shared/model/')
        phrases = analyzedText['response'].split(",")
        sqlsentence = ""
        # iris.cls("Ens.Util.Log").LogInfo("ENCODER.BP.AnalyzeTextProcess", "AnalyzeText", "Starting process")
        for phraseToAnalyze in phrases :
            if phraseToAnalyze != "":
                print(phraseToAnalyze)
    except Exception as err:
        iris.cls("Ens.Util.Log").LogInfo("ENCODER.BP.AnalyzeTextProcess", "AnalyzeText", repr(err))
        return repr(err)

    return "Success"

}

}
