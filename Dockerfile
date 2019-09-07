FROM python:3.7

RUN apt-get clean \
 && apt-get update -qq  \
 && apt-get install -y default-mysql-client

ENV PYTHONUNBUFFERED 1
ENV DJANGO_ENV dev

COPY ./requirements.txt /code/requirements.txt

RUN pip install --upgrade pip
RUN pip install -r /code/requirements.txt
RUN pip install gunicorn

COPY . /code/
WORKDIR /code/

RUN python manage.py migrate

EXPOSE 80
CMD exec gunicorn lw.core.wsgi:application --bind 0.0.0.0:80 --workers 3
