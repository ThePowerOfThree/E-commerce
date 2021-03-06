# Use an official Python runtime as a parent image
FROM python:3.8.5

# Install curl, node, & yarn
RUN apt-get -y install curl \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash \
  && apt-get install nodejs \
  && curl -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /app/backend

# Install Python dependencies
COPY ./backend/requirements /app/backend/requirements
RUN pip install -r requirements/requirements.txt

# Install JS dependencies
WORKDIR /app/frontend

COPY ./frontend/package.json /app/frontend/
RUN $HOME/.yarn/bin/yarn install

# Add the rest of the code
COPY . /app

# Build static files
RUN $HOME/.yarn/bin/yarn build

# Have to move all static files other than index.html to root/
# for whitenoise middleware
WORKDIR /app/frontend/build

RUN mkdir root && mv *.ico *.png *.txt *.json root

# Collect static files
RUN mkdir /app/backend/staticfiles

WORKDIR /app

# SECRET_KEY is only included here to avoid raising an error when generating static files
RUN DJANGO_SETTINGS_MODULE=backend.settings.production \
  SECRET_KEY=somethingsupersecret \
  python backend/manage.py collectstatic --noinput

EXPOSE $PORT

CMD [ "gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "backend.wsgi" , '--chdir', 'backend', '--log-file', '-']

