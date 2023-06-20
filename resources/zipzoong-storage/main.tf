module "s3_public" {
  source        = "../../modules/s3"
  service       = local.service
  name          = "public"
  attach_policy = true
  policy        = <<EOT
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::zipzoong-public/*"
        },{
            "Effect": "Allow",
            "Principal": [${data.backend_main.arn}],
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::zipzoong-public/*"
        }
    ]
}
  EOT
}

module "s3_private" {
  source  = "../../modules/s3"
  service = local.service
  name    = "private"
}

module "s3_internal" {
  source  = "../../modules/s3"
  service = local.service
  name    = "internal"
}
