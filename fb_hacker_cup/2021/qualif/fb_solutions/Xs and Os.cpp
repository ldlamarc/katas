// Xs and Os
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

char C[50][51];

void ProcessCase()
{
  int N, i, j;
  int ans1 = INF, ans2;
  set<PR> S;
  Read(N);
  Fox(i, N)
    scanf("%s", &C[i]);
  // rows
  Fox(i, N)
  {
    vector<int> emp;
    Fox(j, N)
    {
      if (C[i][j] == 'O')
        break;
      if (C[i][j] == '.')
        emp.pb(j);
    }
    if (j == N)
    {
      int c = Sz(emp);
      if (c < ans1)
        ans1 = c, ans2 = 0;
      if (c == 1)
        S.insert(mp(i, emp[0]));
      else if (c == ans1)
        ans2++;
    }
  }
  // cols
  Fox(i, N)
  {
    vector<int> emp;
    Fox(j, N)
    {
      if (C[j][i] == 'O')
        break;
      if (C[j][i] == '.')
        emp.pb(j);
    }
    if (j == N)
    {
      int c = Sz(emp);
      if (c < ans1)
        ans1 = c, ans2 = 0;
      if (c == 1)
        S.insert(mp(emp[0], i));
      else if (c == ans1)
        ans2++;
    }
  }
  // output
  if (ans1 == INF)
    printf("Impossible\n");
  else
    printf("%d %d\n", ans1, ans1 == 1 ? Sz(S) : ans2);
}

int main()
{
  int T, t;
  Read(T);
  Fox1(t, T)
  {
    printf("Case #%d: ", t);
    ProcessCase();
  }
  return(0);
}