module "secrets" {
  source = "./secrets"
}

module "vpc" {
  source = "./vpc"
}

module "domain" {
  source          = "./domain"
  domain_name     = local.backend_domain_name
  wildcard_domain = local.wildcard_domain
  arguments = [{
    dns_name               = module.ecs.alb_dns_name
    zone_id                = module.ecs.aws_alb.zone_id
    evaluate_target_health = false
  }]
}

module "vpn" {
  source          = "./vpn"
  vpn_domain_name = local.vpn_domain_name
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subents_id
  vpc_cidr        = module.vpc.vpc_cidr
}

module "opensearch" {
  source                        = "./opensearch"
  domain                        = "meetmap-app-opensearch"
  ebs_volume_size               = 10
  engine_version                = "2.7"
  instance_count                = 2
  instance_type                 = "t3.small.search"
  custom_domain                 = local.opensearch_domain_name
  custom_domain_certificate_arn = module.domain.certificate_arn
  subnet_ids                    = module.vpc.private_subents_id
  vpc_id                        = module.vpc.vpc_id
  depends_on                    = [module.ecs]
}


//@todo rename to services
module "ecs" {
  source          = "./services"
  vpc_id          = module.vpc.vpc_id
  alb_subents     = module.vpc.public_subents_id
  is_https        = true
  certificate_arn = module.domain.certificate_arn
  arguments = [{
    containerPort = 3001
    name          = "users-service"
    replicas      = 1
    # security_groups = [module.vpc.private_sg_id]
    subnets  = module.vpc.private_subents_id
    publicIp = true
    prefix   = "users"
    env_vars = [
      {
        name  = "RABBIT_MQ_URL"
        value = module.secrets.secrets.RABBIT_MQ_URL
      },
      {
        name  = "USERS_SERVICE_DATABASE_URL"
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
      containerPort = 3000
      name          = "events-service"
      prefix        = "events"
      replicas      = 1
      # cpu           = "512"
      # memory        = "1024"
      # security_groups = [module.vpc.private_sg_id]
      subnets  = module.vpc.private_subents_id
      publicIp = false
      env_vars = [
        {
          name  = "GOOGLE_MAPS_API_KEY"
          value = module.secrets.secrets.GOOGLE_MAPS_API_KEY
        },
        {
          name  = "SEARCH_CLIENT_URL"
          value = module.secrets.secrets.SEARCH_CLIENT_URL
        },
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
        },
        {
          name  = "OPENAI_API_KEY"
          value = module.secrets.secrets.OPENAI_API_KEY
        },
        {
          name  = "EVENTS_SERVICE_DATABASE_URL"
          value = module.secrets.secrets.EVENTS_FETCHER_DATABASE_URL
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

        {
          name  = "DASHBOARD_JWT_AT_SECRET"
          value = module.secrets.secrets.DASHBOARD_JWT_AT_SECRET
        },
        {
          name  = "DASHBOARD_JWT_RT_SECRET"
          value = module.secrets.secrets.DASHBOARD_JWT_RT_SECRET
        },
        {
          name  = "DASHBOARD_JWT_AT_EXPIRES"
          value = module.secrets.secrets.DASHBOARD_JWT_AT_EXPIRES
        },
        {
          name  = "DASHBOARD_JWT_RT_EXPIRES"
          value = module.secrets.secrets.DASHBOARD_JWT_RT_EXPIRES
        },
      ]
    },
    {
      containerPort = 3002
      name          = "location-service"
      prefix        = "location"
      replicas      = 1
      # security_groups = [module.vpc.private_sg_id]
      subnets  = module.vpc.private_subents_id
      publicIp = false
      env_vars = [
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
        },
        {
          name  = "LOCATION_SERVICE_DATABASE_URL"
          value = module.secrets.secrets.LOCATION_SERVICE_DATABASE_URL
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
      containerPort = 3003
      name          = "auth-service"
      prefix        = "auth"
      replicas      = 1
      # security_groups = [module.vpc.private_sg_id]
      subnets  = module.vpc.private_subents_id
      publicIp = false
      env_vars = [
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
        },
        {
          name  = "AUTH_SERVICE_DATABASE_URL"
          value = module.secrets.secrets.AUTH_SERVICE_DATABASE_URL
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
        {
          name  = "FB_CLIENT_ID"
          value = module.secrets.secrets.FB_CLIENT_ID
        },
        {
          name  = "FB_CLIENT_SECRET"
          value = module.secrets.secrets.FB_CLIENT_SECRET
        },
      ]
    },
    {
      containerPort = 3004
      name          = "assets-service"
      prefix        = "assets"
      replicas      = 1
      # security_groups = [module.vpc.private_sg_id]
      subnets  = module.vpc.private_subents_id
      publicIp = false
      env_vars = [
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
        },
        {
          name  = "ASSETS_SERVICE_DATABASE_URL"
          value = module.secrets.secrets.ASSETS_SERVICE_DATABASE_URL
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
        {
          name  = "FB_CLIENT_ID"
          value = module.secrets.secrets.FB_CLIENT_ID
        },
        {
          name  = "FB_CLIENT_SECRET"
          value = module.secrets.secrets.FB_CLIENT_SECRET
        },
      ]
    },
    {
      containerPort = 3005
      name          = "jobs-service"
      prefix        = "jobs"
      replicas      = 1
      # security_groups = [module.vpc.private_sg_id]
      subnets  = module.vpc.private_subents_id
      publicIp = false
      env_vars = [
        {
          name  = "RABBIT_MQ_URL"
          value = module.secrets.secrets.RABBIT_MQ_URL
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
        }
      ]
    },

  ]
}

