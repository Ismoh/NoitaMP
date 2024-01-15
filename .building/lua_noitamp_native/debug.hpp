#pragma once

#ifdef _DEBUG
#include <cstdio>
#define DBG(fmt, ...) printf("XXX %s:%d " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#else
#define DBG(...)
#endif

