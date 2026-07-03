# Python Flask Hello World

A simple Flask web application that displays a "Hello, World!" page with a clickable button.

## Requirements

- Python 3.8+
- Flask 3.x

## Setup & Run

```bash
pip install -r requirements.txt
python src/app.py
```

Then open [http://localhost:5000](http://localhost:5000) in your browser.

## Project Structure

```
.
├── src/
│   ├── app.py                  # Flask application entry point
│   └── templates/
│       └── index.html          # Hello World UI
├── requirements.txt
└── README.md
```

## Routes

| Method | Path     | Description                    |
|--------|----------|--------------------------------|
| GET    | `/`      | Renders the Hello World page   |
| POST   | `/click` | Returns updated button message |
aws test project
