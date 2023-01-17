locals {
   openid_connect_url = try(element(split("oidc-provider/", "${aws_iam_openid_connect_provider.this[0].arn}"), 1),null)
   common_tags = merge(var.additional_tags,{})
}
