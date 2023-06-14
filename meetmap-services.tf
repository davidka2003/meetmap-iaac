module "secrets" {
  source = "./secrets"
}

module "vpc" {
  source = "./vpc"
}

module "ecs" {
  source      = "./services"
  vpc_id      = module.vpc.vpc_id
  alb_subents = module.vpc.public_subents_id

  arguments = [{
    containerPort   = 3001
    name            = "main-app"
    replicas        = 1
    security_groups = [module.vpc.private_sg_id]
    subnets         = module.vpc.private_subents_id
    publicIp        = true
    env_vars = [
      {
        name  = "RABBIT_MQ_URL"
        value = module.secrets.secrets.RABBIT_MQ_URL
      },
      {
        name  = "EVENTS_FETCHER_API_URL"
        value = module.secrets.secrets.EVENTS_FETCHER_API_URL
      },
      {
        name  = "MAIN_APP_API_URL"
        value = module.secrets.secrets.MAIN_APP_API_URL
      },
      {
        name  = "LOCATION_SERVICE_API_URL"
        value = module.secrets.secrets.LOCATION_SERVICE_API_URL
      },
      {
        name  = "EVENTS_FETCHER_DATABASE_URL"
        value = module.secrets.secrets.EVENTS_FETCHER_DATABASE_URL
      },
      {
        name  = "MAIN_APP_DATABASE_URL"
        value = module.secrets.secrets.MAIN_APP_DATABASE_URL
      },
      {
        name  = "AWS_ACCESS_KEY_ID"
        value = module.secrets.secrets.AWS_ACCESS_KEY_ID
      },
      {
        name  = "AWS_SECRET_ACCESS_KEY"
        value = module.secrets.secrets.AWS_SECRET_ACCESS_KEY
      },
      {
        name  = "AWS_REGION"
        value = module.secrets.secrets.AWS_REGION
      },
      {
        name  = "AWS_S3_ASSESTS_BUCKET"
        value = module.secrets.secrets.AWS_S3_ASSESTS_BUCKET
      },
      {
        name  = "CACHE_ENDPOINT"
        value = module.secrets.secrets.CACHE_ENDPOINT
      },
      {
        name  = "JWT_AT_SECRET"
        value = module.secrets.secrets.JWT_AT_SECRET
      },
      {
        name  = "JWT_RT_SECRET"
        value = module.secrets.secrets.JWT_RT_SECRET
      },
      {
        name  = "JWT_AT_EXPIRES"
        value = module.secrets.secrets.JWT_AT_EXPIRES
      },
      {
        name  = "JWT_RT_EXPIRES"
        value = module.secrets.secrets.JWT_RT_EXPIRES
      },
    ]
    },
    {
      containerPort   = 3000
      name            = "events-fetcher"
      replicas        = 1
      security_groups = [module.vpc.private_sg_id]
      subnets         = module.vpc.private_subents_id
      publicIp        = false
      env_vars = [
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
        },
        {
          name  = "EVENTS_FETCHER_API_URL"
          value = module.secrets.secrets.EVENTS_FETCHER_API_URL
        },
        {
          name  = "MAIN_APP_API_URL"
          value = module.secrets.secrets.MAIN_APP_API_URL
        },
        {
          name  = "LOCATION_SERVICE_API_URL"
          value = module.secrets.secrets.LOCATION_SERVICE_API_URL
        },
        {
          name  = "EVENTS_FETCHER_DATABASE_URL"
          value = module.secrets.secrets.EVENTS_FETCHER_DATABASE_URL
        },
        {
          name  = "MAIN_APP_DATABASE_URL"
          value = module.secrets.secrets.MAIN_APP_DATABASE_URL
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = module.secrets.secrets.AWS_ACCESS_KEY_ID
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = module.secrets.secrets.AWS_SECRET_ACCESS_KEY
        },
        {
          name  = "AWS_REGION"
          value = module.secrets.secrets.AWS_REGION
        },
        {
          name  = "AWS_S3_ASSESTS_BUCKET"
          value = module.secrets.secrets.AWS_S3_ASSESTS_BUCKET
        },
        {
          name  = "CACHE_ENDPOINT"
          value = module.secrets.secrets.CACHE_ENDPOINT
        },
        {
          name  = "JWT_AT_SECRET"
          value = module.secrets.secrets.JWT_AT_SECRET
        },
        {
          name  = "JWT_RT_SECRET"
          value = module.secrets.secrets.JWT_RT_SECRET
        },
        {
          name  = "JWT_AT_EXPIRES"
          value = module.secrets.secrets.JWT_AT_EXPIRES
        },
        {
          name  = "JWT_RT_EXPIRES"
          value = module.secrets.secrets.JWT_RT_EXPIRES
        },
      ]
    },
    {
      containerPort   = 3002
      name            = "location-service"
      replicas        = 1
      security_groups = [module.vpc.private_sg_id]
      subnets         = module.vpc.private_subents_id
      publicIp        = false
      env_vars = [
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
        },
        {
          name  = "EVENTS_FETCHER_API_URL"
          value = module.secrets.secrets.EVENTS_FETCHER_API_URL
        },
        {
          name  = "MAIN_APP_API_URL"
          value = module.secrets.secrets.MAIN_APP_API_URL
        },
        {
          name  = "LOCATION_SERVICE_API_URL"
          value = module.secrets.secrets.LOCATION_SERVICE_API_URL
        },
        {
          name  = "LOCATION_SERVICE_DATABASE_URL"
          value = module.secrets.secrets.LOCATION_SERVICE_DATABASE_URL
        },
        {
          name  = "EVENTS_FETCHER_DATABASE_URL"
          value = module.secrets.secrets.EVENTS_FETCHER_DATABASE_URL
        },
        {
          name  = "MAIN_APP_DATABASE_URL"
          value = module.secrets.secrets.MAIN_APP_DATABASE_URL
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = module.secrets.secrets.AWS_ACCESS_KEY_ID
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = module.secrets.secrets.AWS_SECRET_ACCESS_KEY
        },
        {
          name  = "AWS_REGION"
          value = module.secrets.secrets.AWS_REGION
        },
        {
          name  = "AWS_S3_ASSESTS_BUCKET"
          value = module.secrets.secrets.AWS_S3_ASSESTS_BUCKET
        },
        {
          name  = "CACHE_ENDPOINT"
          value = module.secrets.secrets.CACHE_ENDPOINT
        },
        {
          name  = "JWT_AT_SECRET"
          value = module.secrets.secrets.JWT_AT_SECRET
        },
        {
          name  = "JWT_RT_SECRET"
          value = module.secrets.secrets.JWT_RT_SECRET
        },
        {
          name  = "JWT_AT_EXPIRES"
          value = module.secrets.secrets.JWT_AT_EXPIRES
        },
        {
          name  = "JWT_RT_EXPIRES"
          value = module.secrets.secrets.JWT_RT_EXPIRES
        },
      ]
    },
    {
      containerPort   = 3003
      name            = "auth-service"
      replicas        = 1
      security_groups = [module.vpc.private_sg_id]
      subnets         = module.vpc.private_subents_id
      publicIp        = false
      env_vars = [
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
        },
        {
          name  = "EVENTS_FETCHER_API_URL"
          value = module.secrets.secrets.EVENTS_FETCHER_API_URL
        },
        {
          name  = "MAIN_APP_API_URL"
          value = module.secrets.secrets.MAIN_APP_API_URL
        },
        {
          name  = "LOCATION_SERVICE_API_URL"
          value = module.secrets.secrets.LOCATION_SERVICE_API_URL
        },
        {
          name  = "AUTH_SERVICE_DATABASE_URL"
          value = module.secrets.secrets.AUTH_SERVICE_DATABASE_URL
        },
        {
          name  = "MAIN_APP_DATABASE_URL"
          value = module.secrets.secrets.MAIN_APP_DATABASE_URL
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = module.secrets.secrets.AWS_ACCESS_KEY_ID
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = module.secrets.secrets.AWS_SECRET_ACCESS_KEY
        },
        {
          name  = "AWS_REGION"
          value = module.secrets.secrets.AWS_REGION
        },
        {
          name  = "AWS_S3_ASSESTS_BUCKET"
          value = module.secrets.secrets.AWS_S3_ASSESTS_BUCKET
        },
        {
          name  = "CACHE_ENDPOINT"
          value = module.secrets.secrets.CACHE_ENDPOINT
        },
        {
          name  = "JWT_AT_SECRET"
          value = module.secrets.secrets.JWT_AT_SECRET
        },
        {
          name  = "JWT_RT_SECRET"
          value = module.secrets.secrets.JWT_RT_SECRET
        },
        {
          name  = "JWT_AT_EXPIRES"
          value = module.secrets.secrets.JWT_AT_EXPIRES
        },
        {
          name  = "JWT_RT_EXPIRES"
          value = module.secrets.secrets.JWT_RT_EXPIRES
        },
      ]
    },
  ]
}
