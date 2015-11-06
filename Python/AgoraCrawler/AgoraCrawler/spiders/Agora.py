# -*- coding: utf-8 -*-

from scrapy.spiders import Spider
from scrapy import Selector
import logging

from AgoraCrawler.items import AgoraItem

class AgoraSpider(Spider):

    name = "Agora"
    allowed_domains = ["daum.net"]
    start_urls = [
        "http://agora.daum.net/nsearch/total?query=두산베어스&sort_type=1"
         ]

    def parse(self, response):
        hxs = Selector(response)
        logging.info(response)
        contents = hxs.xpath("//*[@class='sResult']//dl")
        items = []

        for content in contents:
            item = AgoraItem()
            item['url'] = content.xpath("dt/a/@href").extract()
            item['date'] = content.xpath("dt/span/text()").extract()[0].encode('utf-8')
            item['title'] = content.xpath("dd/text()").extract()[0].encode('utf-8')
            items.append(item)
        return items

