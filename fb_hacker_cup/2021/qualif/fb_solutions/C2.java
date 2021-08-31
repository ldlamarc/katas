import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;
/*

Solution by David Harmeyer

 */
public class C2 {
	static int oo=Integer.MAX_VALUE/2;
	
	public static void main(String[] args) {
		Scanner fs=new Scanner(System.in);
		int T=fs.nextInt();
		for (int tt=0; tt<T; tt++) {
			int n=fs.nextInt(), k=fs.nextInt();
			Node[] nodes=new Node[n];
			for (int i=0; i<n; i++) nodes[i]=new Node(i, fs.nextInt());
			for (int i=1; i<n; i++) {
				int a=fs.nextInt()-1, b=fs.nextInt()-1;
				nodes[a].children.add(nodes[b]);
				nodes[b].children.add(nodes[a]);
			}
			if (n==1 || k==0) {
				System.out.println("Case #"+(tt+1)+": "+nodes[0].value);
				continue;
			}
			nodes[0].dfs(null);
			int ans=nodes[0].go(0, k, 0, 1);
			System.out.println("Case #"+(tt+1)+": "+ans);
		}
	}
	
	static class Node {
		int id;
		int value;
		ArrayList<Node> children=new ArrayList<>();
		int[][][][] dp;
		
		public Node(int id, int value) {
			this.id=id;
			this.value=value;
			dp=new int[100][100][3][2];
			for (int i=0; i<dp.length; i++)
				for (int j=0; j<dp[i].length; j++)
					for (int k=0; k<dp[i][j].length; k++)
						Arrays.fill(dp[i][j][k], -1);
		}
		
		public void dfs(Node par) {
			if (par!=null) children.remove(par);
			for (Node nn:children) nn.dfs(this);
		}
		
		//helper method to call from the parent
		public int go(int nPaths, int canContinueFromRoot) {
			if (canContinueFromRoot==1) {
				return go(0, nPaths, 1, 1);
			}
			else {
				//either can take me or don't need to take me
				int way1=go(0, nPaths, 0, 0);
				int way2=go(0, nPaths, 0, 1);
				return Math.max(way1, way2);
			}
		}
		
		//returns best answer
		public int go(int childAt, int nPathsToUse, int openEdges, int needToUseMe) {
			//if we need to return the root, count it immediately
			int ans=-oo;
			if (dp[childAt][nPathsToUse][openEdges][needToUseMe]!=-1) return dp[childAt][nPathsToUse][openEdges][needToUseMe];
			
			if (openEdges>0 && needToUseMe==1) {
				return value+go(childAt, nPathsToUse, openEdges, 0);
			}
			
			//we could start a path here if we have no open edges
			if (openEdges==0 && nPathsToUse>0) {
				int bonusForTakingMe = needToUseMe==1?value:0;
				ans=Math.max(ans, go(childAt, nPathsToUse-1, 2, 0) + bonusForTakingMe);
			}
			
			//no more kids -> answer is 0 since we would have already counted ourselves
			if (childAt==children.size()) {
				if (needToUseMe==0) {
					ans=Math.max(ans, 0);
				}
				return ans;
			}
			
			Node kid=children.get(childAt);
			for (int pathsToGiveKid=0; pathsToGiveKid<=nPathsToUse; pathsToGiveKid++) {
				
				if (openEdges>0) {
					//consider passing edge down to kid
					int futureMe=go(childAt+1, nPathsToUse-pathsToGiveKid, openEdges-1, 0);
					int futureHim=kid.go(pathsToGiveKid, 1);
					int bonus=needToUseMe==1?value:0;
					ans=Math.max(ans, futureMe+futureHim+bonus);
				}
				
				//don't give this kid anything
				int futureMe=go(childAt+1, nPathsToUse-pathsToGiveKid, openEdges, needToUseMe);
				int futureHim=kid.go(pathsToGiveKid, 0);
				ans=Math.max(ans, futureMe+futureHim);
			}
			
			return dp[childAt][nPathsToUse][openEdges][needToUseMe] = ans;
		}
	}
}
