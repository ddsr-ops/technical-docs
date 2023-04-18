pip install virtualenv

cd my-project
virtualenv --python C:\Path\To\Python\python.exe venv

.\venv\Scripts\activate

pip freeze > requirements.txt

pip install -r requirements.txt

deactivate

[Reference](https://mothergeo-py.readthedocs.io/en/latest/development/how-to/venv-win.html)