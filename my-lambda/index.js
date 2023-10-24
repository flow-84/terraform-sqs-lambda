const AWS = require('aws-sdk');
const sqs = new AWS.SQS();

exports.handler = async (event) => {
  const queueURL = process.env.QUEUE_URL;

  const params = {
    QueueUrl: queueURL,
    MaxNumberOfMessages: 10
  };

  const data = await sqs.receiveMessage(params).promise();

  // Deine Logik hier

  return {
    statusCode: 200,
    body: JSON.stringify('Done'),
  };
};
