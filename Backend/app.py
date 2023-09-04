from flask import Flask, request, Response
from urllib.parse import unquote
from os import listdir
from os.path import join, isfile, isdir
import shutil

app = Flask(__name__)

@app.route("/")
def hello():
  encoded_dir = request.args.get('dir')
  dir = unquote(encoded_dir)
  files = [join(dir, f) for f in listdir(dir)]

  return files

@app.route("/save", methods = ['POST'])
def save_file():
  save_request = request.get_json()
  filename = save_request['filename']
  destination = save_request['destination']
  filetypes = save_request['filetypes']
  if isfile(filename) and isdir(destination):
    final_dest = shutil.copy(f'{filename}.{filetypes["origin"]}', f'{destination}/{filename}.{filetypes["destination"]}')
    return Response(status=201) if final_dest is not None else Response(status=500)
  return Response(status=400)
