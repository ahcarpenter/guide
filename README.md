# Guide

A service which allows users to better utilize the time and effort of providers by optimizing routes for a given list of delivery locations.

## Using the API

### Placing requests
Request examples are provided via the Postman collection at the root of this repo in the `guide.postman_collection.json` file.

### Example Response

```json
{
    "data": {
        "addresses": [
            {
                "street_address": "1005 Flagpole Ct., Brentwood, TN 37027",
                "coordinates": [
                    35.95785,
                    -86.80502
                ]
            },
            {
                "street_address": "333 Commerce St, Nashville, TN 37201",
                "coordinates": [
                    36.16211,
                    -86.7771
                ]
            }
        ]
    }
}
```

## Local Dev Setup

1. Start by ensuring you have Docker Compose installed. Instructions are available [here](https://docs.docker.com/compose/install/).

2. Once you have `docker-compose` installed. Visit the root of the repo and execute the following commands to get started.

  - `docker-compose up`
  - (In a separate terminal) `docker-compose run web rails db:setup`

3. You're now setup and ready to start sending requests to http://localhost:3000

### Notes

Currently not implemented, but think it would be neat to have a second async POST endpoint which could be used to handle larger scale batch sizes more effectively. We could leverage Sidekiq, Redis, Routific's async endpoint, and HERE's async endpoint for batch geocoding. We could setup it up such that the POST endpoint returns a job id of some sort which can then be used to poll a separate endpoint for status. In the context of a complete job, we could also have that endpoint add the output to response.
