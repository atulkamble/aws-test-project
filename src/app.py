from flask import Flask, render_template, request, jsonify

app = Flask(__name__)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/click", methods=["POST"])
def click():
    return jsonify({"message": "You clicked the button!"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
