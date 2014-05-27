public class bpoCallOut{

// Pass in the endpoint to be used using the string url
  public String getContent(String url) {

// Instantiate a new http object
    Http h = new Http();
    string test = 'https://online.backpacksoftware.com/api/import/roomtypes';

// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    //req.setEndPoint(test);
    req.setMethod('GET');

// Send the request, and return a response
//Again making change
    HttpResponse res = h.send(req);
    System.debug(res.getBody());
    return res.getBody();
    

  }
}