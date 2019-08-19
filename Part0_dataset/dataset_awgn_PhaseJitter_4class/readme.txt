训练集
总共100000x4个Seq
Seq内相同 Es/No ~ U(-10, 20)(dB)
Seq内不同(每个Symbol都不同) Phase Jitter ~ U(0, pi/2)

测试集
固定Es/No = 10dB
Phase Jitter Bound从0 ~ 90°中每隔5°选取一个测试对应分类性能，每个Phase Jitter Bound测试1000x4(类别数)个Seq。
Phase Jitter Bound是具体生成Seq的Phase Jitter ~ U(0, Phase Jitter Bound)
