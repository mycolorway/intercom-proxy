# README

## how it works
intercom first loads https://widget.intercom.io/widget/:app_id, which is hosted on cloudfront.net and 302 to https://js.intercomcdn.com/shim.xxx.js, which also hosted on cloudfront.net. Then shim.xxx.js will load https://js/intercomcdn.com/frame.xxx.js. Under certain network condition cloudfront.net has trouble being accessed. This service load and modifies the assets as a proxy.

## getting started
First, [setup docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/). Then:  
```
docker-compose up --build
```

## config
Default values in [.env](.env) and override them in .env.local  
See https://github.com/bkeepers/dotenv

## cache and distribute on OSS
Will upload assets then redirect to OSS when ENV['OSS_XXX'] are present.  
Recommand to set OSS bucket referer restraint.
