// Gold Mine - Chapter 2
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
#define Foxen(i,s) for (i=s.begin(); i!=s.end(); i++)
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

#define LIM 52

int N, K;
int C[LIM];
vector<int> con[LIM];

// dyn[i][j][k] = max. value in i's subtree,
// with j new paths present,
// and with a free path ongoing from i's parent if k=1
int dyn[LIM][LIM][2];

// dyn2[i][j][k][c] = max. value after first i children of current node,
// with j new paths present,
// and with a free path available for use if k=1,
// and with at least one child connected if c=1
int dyn2[LIM][LIM][2][2];

void rec(int i, int p)
{
  int nc, j, a1, a2, x, y, o, d, d2;
  // recurse to children
  nc = 0;
  for (auto c : con[i])
  {
    if (c == p)
      continue;
    rec(c, i);
    nc++;
  }
  // sub-DP
  Fox(j, nc + 1)
    Fill(dyn2[j], -1);
  dyn2[0][0][0][0] = 0;
  nc = 0;
  for (auto c : con[i])
  {
    if (c == p)
      continue;
    Fox(a1, K + 1)
    {
      Fox(x, 2)
      {
        Fox(y, 2)
        {
          if ((d = dyn2[nc][a1][x][y]) < 0)
            continue;
          Fox(a2, K + 1 - a1)
          {
            // connect to child
            d2 = dyn[c][a2][1];
            if (d2 >= 0)
              Max(dyn2[nc + 1][a1 + a2 + (x ? 0 : 1)][1 - x][1], d + d2);
            // don't connect to child
            d2 = dyn[c][a2][0];
            if (d2 >= 0)
              Max(dyn2[nc + 1][a1 + a2][x][y], d + d2);
          }
        }
      }
    }
    nc++;
  }
  // combine into main DP
  Fill(dyn[i], -1);
  Fox(o, 2)
  {
    Fox(j, K + 1)
    {
      Fox(x, 2)
      {
        Fox(y, 2)
        {
          if (!i && !y) // root must connect to at least one child
            continue;
          if ((d = dyn2[nc][j][x][y]) < 0)
            continue;
          // include current node's value?
          if (o || y)
            d += C[i];
          // free path ongoing from parent?
          Max(dyn[i][j - (o && x ? 1 : 0)][o], d);
        }
      }
    }
  }
}

int ProcessCase()
{
  int i;
  // init
  Fox(i, N)
    con[i].clear();
  // input
  Read(N), Read(K);
  Fox(i, N)
    Read(C[i]);
  Fox(i, N - 1)
  {
    int a, b;
    Read(a), Read(b), a--, b--;
    con[a].pb(b);
    con[b].pb(a);
  }
  // DP
  rec(0, -1);
  int ans = C[0];
  Fox(i, K + 1)
    Max(ans, dyn[0][i][0]);
  return(ans);
}

int main()
{
  int T, t;
  Read(T);
  Fox1(t, T)
    printf("Case #%d: %d\n", t, ProcessCase());
  return(0);
}