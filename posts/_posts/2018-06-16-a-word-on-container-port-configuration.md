---
layout: post
published: true
title: "A word on container port configuration"
tags: [containers]
---

One thing I find weird about basic Dockerfile [examples](https://docs.docker.com/get-started/part2/#define-a-container-with-dockerfile) 
is that the exposed port is baked into the image.
This would seem to make the image less portable.
What if there is another process already listening on the same port?
That isn't a problem because container ports are mapped to host ports.
If container A and container B both expose port `3000`, A can be mapped to 
`3001` and B can be mapped to `3002`.

The weirdness starts within the container. 
If the container exposes port `3000`, then the application running inside the 
container _must_ listen on port `3000`.
The application will be unreachable if it's listening on port `3001`.
For this reason, it might seem prudent to hardcode the port number into the
application code.
But then the application is coupled to the Docker environment.

What I really want is a single place to configure the port exposed by the
container and the port the application listens on.
Then the two will always be consistent.
Here is a way to do that:

1. Remove the `EXPOSE` directive from the Dockerfile.
1. Create a `.env` file.
1. Set an `APP_PORT` environmental variable in the `.env` file.
1. Reference `APP_PORT` when starting the server. For example: 
`app.listen(process.env.APP_PORT);`
1. Run the container with this command:

{% highlight bash %}
source .env

docker run \
  --env-file .env \
  --expose $MY_APP_PORT \
  --publish <host port>:$MY_APP_PORT
  <image name>
{% endhighlight %}

Thus the `.env` file is the single point of configuration for all places where the 
port number should be identical.
