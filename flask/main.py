import nltk
from flask import Flask, jsonify, request
from textblob import TextBlob
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize, sent_tokenize

app = Flask(__name__)


@app.route('/')
def hello_world():
    json_file = {'query': 'hello_world'}
    return jsonify(json_file)


@app.route('/sentiment', methods=['POST'])
def get_sentiment():
    json_file = {'sentiment_value': TextBlob(request.json['to_analyze']).sentiment.polarity}
    return jsonify(json_file)


@app.route('/summarize', methods=['POST'])
def summarize_text():
    nltk.download('stopwords')
    stop_words = set(stopwords.words("english"))
    words = word_tokenize(request.json['to_summarize'])

    frequencies = dict()
    for word in words:
        word = word.lower()
        if word in stop_words:
            continue
        if word in frequencies:
            frequencies[word] += 1
        else:
            frequencies[word] = 1

    sentences = sent_tokenize(request.json['to_summarize'])
    sentence_scores = dict()
    for sentence in sentences:
        for word, frequency in frequencies.items():
            if word in sentence.lower():
                if sentence in sentence_scores:
                    sentence_scores[sentence] += 1
                else:
                    sentence_scores[sentence] = frequency

    sum_values = 0
    for sentence in sentence_scores:
        sum_values += sentence_scores[sentence]

    average = int(sum_values / len(sentence_scores))

    summary = ''
    threshold = 1.2
    for sentence in sentences:
        if (sentence in sentence_scores) and (sentence_scores[sentence] > (threshold * average)):
            summary += " " + sentence

    json_file = {'summary': summary}
    return jsonify(json_file)


if __name__ == '__main__':
    app.run()
