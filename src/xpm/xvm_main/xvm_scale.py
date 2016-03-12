""" XVM (c) www.modxvm.com 2013-2015 """
"""
 XVM Scale for ratings
 http://www.koreanrandom.com/forum/topic/2625-/
 @author seriych <seriych(at)modxvm.com>
 @author Maxim Schedriviy <max(at)modxvm.com>
"""

import xvm_scale_data

def XEFF(x):
    return 100 if x > 2250 else		\
        round(max(0, min(100,		\
            x*(x*(x*(x*(x*(x*		\
            0.000000000000000013172	\
            - 0.000000000000092286)	\
            + 0.00000000023692)	\
            - 0.00000027377)		\
            + 0.00012983)		\
            + 0.05935)			\
            - 31.684)))

def XWN6(x):
    return 100 if x > 2350 else		\
        round(max(0, min(100,		\
            x*(x*(x*(x*(x*(x*		\
            0.000000000000000001225	\
            - 0.000000000000007167)	\
            + 0.000000000005501)	\
            + 0.00000002368)		\
            - 0.00003668)		\
            + 0.05965)			\
            - 5.297)))

def XWN8(x):
    return 100 if x > 3650 else		\
        round(max(0, min(100,		\
            x*(x*(x*(x*(x*(-x*		\
            0.00000000000000000007656	\
            + 0.0000000000000014848)	\
            - 0.0000000000099633)	\
            + 0.00000002858)		\
            - 0.00003836)		\
            + 0.0575)			\
            - 0.99)))

def XWGR(x):
    return 100 if x > 11100 else	\
        round(max(0, min(100,		\
            x*(x*(x*(x*(x*(-x*		\
            0.0000000000000000000013018	\
            + 0.00000000000000004812)	\
            - 0.00000000000071831)	\
            + 0.0000000055583)		\
            - 0.000023362)		\
            + 0.059054)			\
            - 47.85)))

def XvmScaleToSup(x):
    if x is None:
        return None
    return xvm_scale_data.xvm2sup[max(0, min(100, x))]
