provider "aws" {
  alias  = "mi4cc"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::320132909094:role/test_Lambda"
  }
}

resource "aws_cloudwatch_event_rule" "mi4cc_cloudwatch_event_rule-for-sns" {
  name                = "${var.cloudwatch_event_rule_name_for_sns}"
  description         = "${var.cloudwatch_event_rule_description_for_sns}"
#  event_pattern = <<PATTERN
#  {
#  "source": [
#    "aws.glue"
#  ],
#  "detail-type": [
#    "Glue Job State Change"
#  ],
#  "detail": {
#    "state": [
#      "FAILED",
#      "TIMEOUT",
#      "STOPPED"
#    ],
#    "jobName": [
#      "uki-sand-glue-mi4cc-avaya"
#    ]
#  }
#}
#PATTERN
#   event_pattern = "${file("${path.module}/${var.file_name}"}"
    event_pattern = "${var.event_pattern}"
}

resource "aws_cloudwatch_event_target" "mi4cc_cloudwatch_event_target-sns" {
  target_id = "${var.target-id}"
  rule      = "${aws_cloudwatch_event_rule.mi4cc_cloudwatch_event_rule-for-sns.name}"
  arn       = "${var.sns_arn}"
}

