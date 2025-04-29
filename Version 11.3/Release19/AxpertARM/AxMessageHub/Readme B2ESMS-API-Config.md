
# B2ESMS API Configuration and Endpoint Information

## Configuration Details

This section explains the configuration for the B2ESMS API integration in the `appsettings.json` file.

### appsettings.json

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "b2esms": {
    "url": "http://sms.b2etechnology.com/",    // The base URL for the B2ESMS API
    "key": "1c40bcfc90e0dfa152f4bfb85c13ecd8", // API Key for authentication
    "sender": "TRSTLN",                        // The sender ID for the SMS
    "route": "4",                              // The SMS route type (e.g., promotional or transactional)
    "sms": "Hello, Your OTP for accessing TrustLine appneo portal is {#var#}}Please do not disclose this OTP to anyone. -TrustLine Holdings", // The message template
    "templateid": "1707174376927012318",       // The template ID for the SMS message
    "placeholder": "{#var#}"                    // The placeholder for dynamic data (e.g., OTP value)
  },
  "AllowedHosts": "*"
}
```

### Explanation of Configuration Keys:
- **url**: The base URL for the B2ESMS API. Make sure this URL points to the correct endpoint for SMS sending.
- **key**: The unique API key that will authenticate your application with the B2ESMS service.
- **sender**: The sender ID (e.g., your brand or company name) that will appear as the sender of the SMS.
- **route**: The route type for SMS delivery. Route `4` is typically used for transactional messages.
- **sms**: The SMS message template. `{#var#}` is a placeholder for dynamic data, such as an OTP (One Time Password).
- **templateid**: The unique ID of the SMS template you are using for sending the OTP.
- **placeholder**: The placeholder used in the SMS message. This can be adjusted based on the data you wish to inject into the message (e.g., OTP).

## API Endpoint Information

The API endpoint is :

```
api/Messaging/b2esms
```
Ex:  http://localhost/AxMessageHub/api/Messaging/b2esms

To send an SMS, you can use the following API call (example):

**POST** `http://localhost/AxMessageHub/api/Messaging/b2esms`  
**Headers**:
- `Content-Type: application/json`

**Request Body**:
```json
{
    "mobileno": ["+918050451036"],
    "message": ["Hello , Your OTP for accessing TrustLine appneo portal is {#var#}}Please do not disclose this OTP to anyone. -TrustLine Holdings"],
    "otp" : "1234"
}
```

**Response**:
```json
{
  "status": "Success",
  "message": "SMS sent successfully."
}
```

## Notes:
- Ensure that the recipient phone number is in international format.
- The placeholder `{#var#}` will be replaced with the OTP or any dynamic value you want to inject.
- For b2esms, the message body will be taken from the AppSettings configuration, specifically from the b2esms section's sms key value.
Since b2esms works based on a predefined template, it will not allow sending any content other than the template itself.

