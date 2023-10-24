QUEUE_URL="https://sqs.eu-central-1.amazonaws.com/352507159828/my-queue"
AWS_PROFILE="student"

for i in {1..10}
do
  aws sqs send-message \
  --profile $AWS_PROFILE \
  --queue-url $QUEUE_URL \
  --message-body "Test $i"
done
