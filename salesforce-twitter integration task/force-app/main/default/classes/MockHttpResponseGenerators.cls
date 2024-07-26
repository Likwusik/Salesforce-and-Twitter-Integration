@isTest
public class MockHttpResponseGenerators implements HttpCalloutMock {
    private String method;
    private Integer statusCode;
    private String responseBody;

    // Constructor to initialize mock response parameters
    public MockHttpResponseGenerators(String method, Integer statusCode, String responseBody) {
        this.method = method;
        this.statusCode = statusCode;
        this.responseBody = responseBody;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if (req.getMethod() == method) {
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
        } else {
            res.setStatusCode(400);
            res.setBody('Unexpected method or error');
        }
        return res;
    }
}