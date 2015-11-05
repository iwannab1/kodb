package org.kodb.collector.crawler;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class AgoraCrawler {

    private static String baseUrl = "http://agora.daum.net/nsearch/total?query=";
    private static String sortType = "&sort_type=1";

    private Document getDocument(String url) throws Exception {
        Document doc = Jsoup.connect(url).timeout(10000).get();
        return doc;
    }

    private String makeBody(String url, String title, String author, String create, String content) {
        String replaceContent = content.replaceAll("<br>", "\n").replaceAll("<p>", "").replaceAll("</p>", "\n");
        StringBuilder body = new StringBuilder();
        body.append("원문 URL : " + url + "\n");
        body.append("제목 : " + title + "\n");
        body.append("작성자 : " + author + "\t작성시간 : " + create + "\n");
        body.append("본문 : " + replaceContent + "\n");
        return body.toString();
    }

    private void parseHtml(Document document) throws Exception {
        Elements resultEle = document.getElementsByClass("sResult");
        Elements contents = resultEle.first().getElementsByTag("dt");

        for (Element dt : contents) {
            String date = dt.getElementsByClass("date").text();
            Element articleEle = dt.getElementsByTag("a").first();

            String articleUrl = articleEle.attr("href");

            if (articleUrl.indexOf("/livetalk/") < 0) {
                int idx = articleUrl.indexOf("articleId=");
                String articleId = articleUrl.substring(idx + "articleId=".length());
                String title = articleEle.text();

                Document detail = getDocument(articleUrl);
                // 게시물 title 추출
                Element wrap_title = detail.getElementsByClass("wrap_title").first().getElementsByClass("name").first();
                // 게시물 작성자 추출
                String nameStr = wrap_title.getElementsByTag("a").first().text() + wrap_title.getElementsByTag("span").first().text();
                // 게시물 작성일자 추출
                String createAt = detail.getElementsByClass("wrap_info").first().getElementsByClass("date").first().text();
                // 게시물 본문 추출
                String body = detail.getElementsByClass("tx-content-container").first().text();
                // 가져온 내용들로 하나의 String 생성
                String writelog = makeBody(articleUrl, title, nameStr, createAt, body);

                System.out.println(writelog);

            }
        }
    }

    public static void main(String[] args){
        String search = args[0];
        String url = baseUrl + search + sortType;
        AgoraCrawler crawler = new AgoraCrawler();

        try{
            Document doc = crawler.getDocument(url);
            crawler.parseHtml(doc);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
