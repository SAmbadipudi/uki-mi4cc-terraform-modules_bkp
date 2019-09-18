resource "aws_lambda_function" "mi4cc_eventwatch_lambda" {
        function_name = "eventwatch"
        handler = "lambda_function.lambda_handler"
        runtime = "python2.7"
        filename = "files/eventwatch.zip"
        source_code_hash = "${base64sha256(filebase64("files/eventwatch.zip"))}"
        role = "${var.lambda_arn}"
        timeout = 15
}

resource "aws_cloudwatch_event_rule" "mi4cc_cloudwatch_event_rule" {
  count               = "${length("${var.event_rules}")}"
  name                = "${var.cloudwatch_event_rule_name}-${var.event_rules[count.index]}"
  description         = "${var.cloudwatch_event_rule_description}  ${var.event_rules[count.index]}"
  schedule_expression = "${lookup(var.schedule_expression, var.event_rules[count.index])}"
}

resource "aws_cloudwatch_event_target" "mi4cc_cloudwatch_event_target" {
  count     = "${length("${var.event_rules}")}" 
  target_id = "${var.event_rules[count.index]}"
  rule      = "${aws_cloudwatch_event_rule.mi4cc_cloudwatch_event_rule[count.index].name}"
  arn       = "${aws_lambda_function.mi4cc_eventwatch_lambda.arn}"
  input     = "{\"${var.input1}\":\"${var.bucket-name}\",\"${var.input2}\":\"${var.file-path}/${var.event_rules[count.index]}.json\",\"${var.input3}\":\"${var.glue-job-name}\"}"
#  input     = "${var.input_vars}"
}

resource "aws_lambda_permission" "allow_cloudwatch_ec2_events" {
  count     = "${length("${var.event_rules}")}"
  statement_id   = "${var.cloudwatch_lambda_st_id}_${var.event_rules[count.index]}"
  action         = "${var.action_lambda}"
  function_name  = "${aws_lambda_function.mi4cc_eventwatch_lambda.function_name}"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.mi4cc_cloudwatch_event_rule[count.index].arn}"
}
