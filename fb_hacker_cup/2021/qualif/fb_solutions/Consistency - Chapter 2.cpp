// Consistency - Chapter 2
// Solution by Jacob Plachta

#include <algorithm>
#include <functional>
#include <numeric>
#include <iostream>
#include <iomanip>
#include <cstdio>
#include <cmath>
#include <complex>
#include <cstdlib>
#include <ctime>
#include <cstring>
#include <cassert>
#include <string>
#include <vector>
#include <list>
#include <map>
#include <set>
#include <unordered_set>
#include <deque>
#include <queue>
#include <stack>
#include <bitset>
#include <sstream>
using namespace std;

#define LL long long
#define LD long double
#define PR pair<int,int>

#define Fox(i,n) for (i=0; i<n; i++)
#define Fox1(i,n) for (i=1; i<=n; i++)
#define FoxI(i,a,b) for (i=a; i<=b; i++)
#define FoxR(i,n) for (i=(n)-1; i>=0; i--)
#define FoxR1(i,n) for (i=n; i>0; i--)
#define FoxRI(i,a,b) for (i=b; i>=a; i--)
#define Foxen(i,s) for (auto i:s)
#define Min(a,b) a=min(a,b)
#define Max(a,b) a=max(a,b)
#define Sz(s) int((s).size())
#define All(s) (s).begin(),(s).end()
#define Fill(s,v) memset(s,v,sizeof(s))
#define pb push_back
#define mp make_pair
#define x first
#define y second

template<typename T> T Abs(T x) { return(x < 0 ? -x : x); }
template<typename T> T Sqr(T x) { return(x * x); }
string plural(string s) { return(Sz(s) && s[Sz(s) - 1] == 'x' ? s + "en" : s + "s"); }

const int INF = (int)1e9;
const LD EPS = 1e-12;
const LD PI = acos(-1.0);

#define GETCHAR getchar

bool Read(int& x)
{
  char c, r = 0, n = 0;
  x = 0;
  for (;;)
  {
    c = GETCHAR();
    if ((c < 0) && (!r))
      return(0);
    if ((c == '-') && (!r))
      n = 1;
    else
      if ((c >= '0') && (c <= '9'))
        x = x * 10 + c - '0', r = 1;
      else
        if (r)
          break;
  }
  if (n)
    x = -x;
  return(1);
}

string S;
int dist[26][26];

int ProcessCase()
{
  int K, i, j, k, ans = 1e6;
  cin >> S;
  Read(K);
  Fox(i, 26)
  {
    Fox(j, 26)
      dist[i][j] = i == j ? 0 : 1e6;
  }
  while (K--)
  {
    char a, b;
    scanf("%c%c\n", &a, &b);
    dist[a - 'A'][b - 'A'] = 1;
  }
  Fox(i, 26)
  {
    Fox(j, 26)
    {
      Fox(k, 26)
        Min(dist[j][k], dist[j][i] + dist[i][k]);
    }
  }
  Fox(i, 26)
  {
    int cur = 0;
    Foxen(c, S)
      cur += dist[c - 'A'][i];
    Min(ans, cur);
  }
  return(ans == 1e6 ? -1 : ans);
}

int main()
{
  int T, t;
  Read(T);
  Fox1(t, T)
    printf("Case #%d: %d\n", t, ProcessCase());
  return(0);
}