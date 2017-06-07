Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk1.8.0_121")

library(KoNLP)

#useSejongDic()
useNIADic()

extractNoun("롯데마트가 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다.")

extractNoun(c("R은 free 소프트웨어이고, [완전하게 무보증]입니다.", 
              "일정한 조건에 따르면, 자유롭게 이것을 재배포할수가 있습니다.")
)


# simple pos 9

pos <- SimplePos09("롯데마트가 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다.")
pos

pos <- SimplePos09("아버지가방에들어가신다")
pos

# simple pos 22

SimplePos22("롯데마트가 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다.")
SimplePos22("아버지가방에들어가신다")


# 언어형태 분석
MorphAnalyzer("롯데마트가 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다.")
MorphAnalyzer("아버지가방에들어가신다")

# 자모 변환
convertHangulStringToJamos("R는 많은 공헌자에의한 공동 프로젝트입니다")

# 키 입력 변환(2벌식)
convertHangulStringToKeyStrokes("R는 많은 공헌자에의한 공동 프로젝트입니다")


# 사용자 정의 사전 추가
txt <- '미국 싱크탱크 전략국제문제연구소(CSIS)의 빅터 차 한국석좌는 9일(현지시간) 미국의 제45대 대통령으로 당선된 도널드 트럼프가 전시작전통제권(전작권)을 한국에 조기에 넘길 가능성이 있다고 전망했다.'
extractNoun(txt)

buildDictionary(ext_dic = c('sejong', 'woorimalsam'),user_dic = data.frame(term="전작권", tag='ncn'), category_dic_nms=c('political'))

extractNoun(txt)


# 띄어쓰기
extractNoun("아버지가방에들어가셨다.")

extractNoun("아버지가방에들어가셨다.", autoSpacing = T)

MorphAnalyzer("아버지가방에들어가셨다.", autoSpacing = T)

