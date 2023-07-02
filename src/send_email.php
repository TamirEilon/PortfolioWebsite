<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $name = $_POST["name"];
  $email = $_POST["email"];
  $message = $_POST["message"];

  // Set the recipient email address
  $to = "tamireilon@yahoo.com";

  // Set the email subject
  $subject = "New message from contact form";

  // Set the email headers
  $headers = "From: $name <$email>" . "\r\n";
  $headers .= "Reply-To: $email" . "\r\n";
  $headers .= "Content-type: text/html; charset=UTF-8" . "\r\n";

  // Construct the email body
  $body = "<h2>New message from contact form</h2>";
  $body .= "<p><strong>Name:</strong> $name</p>";
  $body .= "<p><strong>Email:</strong> $email</p>";
  $body .= "<p><strong>Message:</strong> $message</p>";

  // Send the email
  if (mail($to, $subject, $body, $headers)) {
    echo "Thank you for your message!";
  } else {
    echo "Oops! Something went wrong.";
  }
}
?>
