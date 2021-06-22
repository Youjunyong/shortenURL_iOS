# shortenURL-iOS-

## 개요

ios와 서버와의 HTTP 요청을 공부하고, Open API를 사용한 간단한 앱을 만들어보고 싶었다.
Naver Open API (https://developers.naver.com/docs/common/openapiguide/)에서 URL을 짧게 줄여주는 서비스가 있길래 사용해보았다.하루 2만 5천회까지 사용 가능하다.

URL만 줄여주는건 너무 간단한것 같아서, 해당 URL의 HTML을 파싱한 후에, ogtag-img를 가져왔다. 그리고 이를 이용해 history(bookmark) 페이지를 하나 더 구성해보았다.




## 작동 화면
![Simulator Screen Recording - iPhone 12 - 2021-06-22 at 19 44 18](https://user-images.githubusercontent.com/46234386/122911652-7960b900-d392-11eb-8cc2-0bb48e33442b.gif)



## Naver API

요청 방법은 네이버 api 링크에서 자세하게 설명 되어있다.



> curl

```shell
curl "https://openapi.naver.com/v1/util/shorturl" \
    -d "url=http://d2.naver.com/helloworld/4874130" \
    -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
    -H "X-Naver-Client-Id: {애플리케이션 등록 시 발급받은 클라이언트 아이디 값}" \
    -H "X-Naver-Client-Secret: {애플리케이션 등록 시 발급받은 클라이언트 시크릿 값}" -v
```

curl로 응답을 받아보면

> 응답

```json
{
    "message":"ok",
    "result": {
        "hash":"GyvykVAu",
        "url":"https://me2.do/GyvykVAu",
        "orgUrl":"http://d2.naver.com/helloworld/4874130"
    }
    ,"code":"200"
}
```

이렇게 응답이 온다. 



> swift Json을 파싱하기 위한 Codable 구조체

```swift
struct Response: Codable {
        struct Container : Codable{
            var orgUrl : String
            var url : String
            var hash : String
        }
        
        var result : Container
        let message : String
        let code: String
    }
```





```swift
func requestGet(query: String, completionHandler: @escaping (Bool, Any) -> Void) {
        let clientID = "클라이언트 ID"
        let clientSecret = "클라이언트 secret"
        let apiUrl : String = "https://openapi.naver.com/v1/util/shorturl.json?url=\(query)"
  
        guard let encodedUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        // percentEncoding을 해주지 않으면, URL에 한글이 들어갔을때 통신이 안돼었다..
        
            return
        }
        guard let url = URL(string: encodedUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    self.orgUrlLabel.text = "유효한 URL을 입력해주세요"
                }
                return
            }
            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                return
            }
            completionHandler(true, output)
        }.resume()
    }
```

