from typing import Union

from fastapi import FastAPI
from fastapi.responses import HTMLResponse, JSONResponse

app = FastAPI()


@app.get("/", response_class=HTMLResponse)
async def read_root():
    return """
    <html>
        <head>
            <title>Hello from Python + FastAPI ⚡️!</title>
            <meta name="color-scheme" content="light dark">
        </head>
        <body>
            <h3>Hello from Python +FastAPI ⚡️!</h3>
            <p>Visit <a href="/items/9000">/items/9000</a></p>
        </body>
    </html>
    """


@app.get("/items/{item_id}", response_class=JSONResponse)
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
