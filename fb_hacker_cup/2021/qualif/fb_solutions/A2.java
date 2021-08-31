import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.Scanner;

public class Consistancy2 {

	static final String filename="consistency_chapter_1_validation";
	static final boolean submit=true;
	
	static void solve(Scanner fs, PrintWriter out) {
		int T=fs.nextInt();
		for (int tt=0; tt<T; tt++) {
			char[] line=fs.next().toCharArray();
			int best=Integer.MAX_VALUE;
			for (int make=0; make<26; make++) {
				int ans=0;
				char makeC=(char) (make+'A');
				boolean makeV="AEIOU".indexOf(makeC)!=-1;
				for (char c:line) {
					if (c-'A'==make) continue;
					if (makeV==("AEIOU".indexOf(c)!=-1)) ans++;
					ans++;
				}
				best=Math.min(best, ans);
			}
			
			out.println("Case #"+(tt+1)+": "+best);
		}
		
		out.close();
	}
	
	public static void main(String[] args) throws FileNotFoundException {
		if (!submit) solve(new Scanner(System.in), new PrintWriter(System.out));
		else solve(new Scanner(new File(filename+"_input.txt")), new PrintWriter(new File(filename+"_output.out")));
	}
}
