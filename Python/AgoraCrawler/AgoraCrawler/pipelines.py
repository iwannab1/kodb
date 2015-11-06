# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html


from scrapy.exceptions import DropItem
import time

class TodayPipeline(object):

    def getToday(self):
        return time.strftime("%Y.%m")

    def process_item(self, item, spider):
        today = self.getToday()
        if item['date'].startswith(today) or item['date'].endswith('시간전') or item['date'].endswith('분전'):
                return item
        else:
            raise DropItem("이번달 토론이 아닙니다 : %s" % item)
