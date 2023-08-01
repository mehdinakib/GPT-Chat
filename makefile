ifdef ComSpec
	# Use powershell replacements if we're not in a POSIX shell.
	RMRF=powershell function rmrf ($$path) { if (Test-Path $$path) { Remove-Item -Recurse -Force $$path } }; rmrf
	MKDIRP=powershell md -Force
	TOUCH=powershell function touch ($$path) { if(Test-Path $$path) { (Get-ChildItem $$path).LastWriteTime = Get-Date } else { New-Item -ItemType file $$path } }; touch
	CP_P=powershell function cp_p ($$src, $$dest) { Copy-Item -Path $$src -Destination $$dest; (Get-ChildItem $$dest).LastWriteTime = (Get-ChildItem $$src).LastWriteTime }; cp_p
	CP_RP=powershell function cp_rp ($$src, $$dest) { Copy-Item -Path $$src -Destination $$dest -Recurse; (Get-ChildItem $$dest).LastWriteTime = (Get-ChildItem $$src).LastWriteTime }; cp_rp
	MV_F=powershell function mv_f ($$src, $$dest) { Move-Item -Force -Path $$src -Destination $$dest}; mv_f
else
	RMRF=rm -rf
	MKDIRP=mkdir -p
	TOUCH=touch
	CP_P=cp -p
	CP_RP=cp -rp
	MV_F=mv -f
endif
ifeq ($(OS),Windows_NT)
	# Use Windows binaries if we're on Windows, even if we're in a GIT bash shell.
	PYTHON=py -3
	VENV_PYTHON=venv/Scripts/python.exe
	VENV_DOTENV=venv/Scripts/dotenv.exe
	VENV_PYTEST=venv/Scripts/pytest.exe
	VENV_PYINSTALLER=venv/Scripts/pyinstaller.exe
	SITE_PACKAGES=venv/Lib/site-packages
	DOCKER_PLATFORM_LINUX=--platform=linux
	SETDOCKERUSER=
else
	PYTHON=python3
	VENV_PYTHON=venv/bin/python
	VENV_DOTENV=venv/bin/dotenv
	VENV_PYTEST=venv/bin/pytest
	VENV_PYINSTALLER=env/bin/pyinstaller
	SITE_PACKAGES=env/lib/python3.?/site-packages
	DOCKER_PLATFORM_LINUX=
	SETDOCKERUSER=-u $(shell id -u ${USER}):$(shell id -g ${USER})
endif


define log-target
	@echo $$(date) : running $@ >> make.log
endef

all: develop
	@$(log-target)
	echo "donee"

develop: version.txt env
	@$(log-target)
	${VENV_PYTHON} -m pip install -r requirements.txt

version.txt: FORCE
	@$(log-target)
	${PYTHON} version.py --output version.txt

venv/.requirements.stamp: env 
	@$(log-target)
	${VENV_PYTHON} -m pip install -r requirements.txt
	${TOUCH} venv/.requirements.stamp

check-format: venv/.requirements.stamp
	@$(log-target)
	${VENV_PYTHON} -m isort -rc outy --check-only
	${VENV_PYTHON} -m black . --check

check: develop
	@$(log-target)
	${VENV_PYTHON} -m pylint outy

env:
	@$(log-target)
	${PYTHON} -m venv venv

test:
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb
	python -m pytest -vv test_hello.py

lint:
	#hadolint Dockerfile #uncomment to explore linting Dockerfiles
	pylint --disable=R,C,W1203,W0702 app.py
	 
FORCE:
