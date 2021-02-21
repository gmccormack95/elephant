import 'dart:convert';
import 'package:http/http.dart';

class MailchimpManager {

  static String token = '09ce5365efad2acec643ebf817fa5cd7-us14';
  static String listId = '81462be1fe';
  static String baseToken = token.split('-')[0];
  static String datacenter = token.split('-')[1];
  static String basePath = "https://${datacenter}.api.mailchimp.com/";

  static Future<Response> subscribeEmail(String email){
    String authString = "apikey:${baseToken}";
    String encoded = base64.encode(utf8.encode(authString));
 
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "Basic ${encoded}"
    };

    Map<String, dynamic> jsonRqst = {
      "email_address": email,
      "subscribed": "subscribed"
    };

    return post("https://us14.api.mailchimp.com/3.0/lists/$listId/members",
      headers: headers, body: json.encode(jsonRqst));
  }

}

/*
let emailText = (alertViewController.textFields[0] as! UITextField).text
                let mailToSubscribe: [String: AnyObject] = ["email": emailText as AnyObject]
                let params: [String: AnyObject] = ["id": "81462be1fe" as AnyObject, "email": mailToSubscribe as AnyObject, "double_optin": false as AnyObject]
                
                self.dismiss(animated: true, completion: nil)
                
                ChimpKit.shared().apiKey = "62915609dbc9a547d8c1d70abe2c4f4f-us14"
                ChimpKit.shared().callApiMethod("lists/subscribe", withParams: params, andCompletionHandler: {(response, data, error) -> Void in
                    if let httpResponse = response as? HTTPURLResponse {
                        NSLog("Reponse status code: %d", httpResponse.statusCode)
                        let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print(datastring as Any) // printing result of response
                    }
                })
                */