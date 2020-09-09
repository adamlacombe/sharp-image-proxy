# sharp-image-proxy

An on the fly image optimization microservice. 

I'm using this to dynamically resize, compress and serve images on my [blog](https://adamlacombe.com/blog/how-to-convert-images-to-avif-in-nodejs?utm_source=github&utm_medium=repo_readme). 

It's hosted on [Google Cloud Run](https://cloud.google.com/run) behind [Cloudflare](https://www.cloudflare.com/) with the following page rule settings:

![Screenshot from 2020-09-09 19-18-19](https://user-images.githubusercontent.com/2395597/92591864-3df87080-f2d1-11ea-80ed-1fab70a4bbc9.png)

## Run using Docker
```bash
docker run \
  -it --rm \
  -p 8080:8080 \
  --name sharp-image-proxy \
  docker.pkg.github.com/adamlacombe/sharp-image-proxy/sharp-image-proxy:latest
```

## Features
- Resize images proportionally.
- Support for webp, avif, png, jpeg and tiff.

## Options
- url
- width
- height
- format = `webp` | `avif` | `png` | `jpeg` | `tiff`
- quality = `1` - `100` (default `80`)

## Example requests
- `/?url=https://via.placeholder.com/500&width=300`
- `/?url=https://via.placeholder.com/500&width=300&format=webp`
- `/?url=https://via.placeholder.com/500&width=300&format=webp&quality=50`
- `/?url=https://via.placeholder.com/500&width=300&format=avif&quality=30`


[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/adamlacombe/sharp-image-proxy)