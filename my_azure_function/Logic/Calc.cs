
namespace de.cyberbartels.logic
{
    public class Calc
    {
        private int a;
        private int b;

        public Calc(int a, int b)
        {
            this.a = a;
            this.b = b;
        }

        public int Add()
        {
            return a+b;
        }
    }
}
