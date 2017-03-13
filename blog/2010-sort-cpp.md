extends: default.liquid

title:   Howto sort a vector or a list in CPP using STL
date:    27th of January 2010
path:    2010/howto-sort-a-vector-or-a-list-in-c-using-stl
---

A little code snippet that people need very often.
**Note**: This code is probably outdated. If you use C++11 or newer, look for more idiomatic alternatives!


```cpp
/*
* Howto sort a vector or a list in C++ using STL
*/

#include <algorithm>	// Needed for sort() method
#include <vector>	    // STL vector class
#include <list>		    // STL list class
#include <iostream>	    // Needed for cout,endl
using namespace std;	// Save us some typing


/*
* This is a comparison function. It can be used to tell sort()
* how to order the elements in our container (the vector or list).
* You can write a comparator for every data type (i.e. double, string...).
*/
bool comp(const int& num1, const int& num2) {
    return num1 > num2;
}
int main() {
    // SORTING WITH VECTORS //
    vector<int> v;
    // A vector containing integers
    vector<int>::iterator vIt;
    // A pointer to a vector element
    // Insert some values
    v.push_back(5);
    v.push_back(12);
    v.push_back(1);
    /*
    * The generic STL sort function uses three parameters:
    * v.begin()  Iterator pointing at the _beginning_ of the container
    * v.end()    Iterator pointing at the _end_ of it
    * comp       [Optional] A comparison function (see above)
    *
    * The above mentioned iterators must be random access iterators because
    * sort() takes advantage of clever tricks that require direct access to
    * all elements of the vector. This makes it really fast.
    * (Currently introsort is used with O(n*log n) even in worst case).
    *
    * Unfortunately calling sort like that does not look very object oriented.
    */
    sort(v.begin(), v.end(), comp);
    cout << "Vector: ";
    for (vIt = v.begin(); vIt != v.end(); vIt++) {
        cout << *vIt << " ";
        // Print current element to standard output
    }
    cout << endl;
    // SORTING WITH LISTS //
    list<int> l;
    // A list containing integers
    list<int>::iterator lIt;
    // A pointer to a list element
    // Insert some values
    l.push_back(5);
    l.push_back(12);
    l.push_back(1);
    /*
    * Here is the major difference between vectors and lists in general:
    * Vectors offer fast random access to every element
    * but inserting a new element at the beginning or in the middle is slow.
    * On the other hand inserting into a list is fast but searching for
    * a specific element is slow. Vectors behave much like an array
    * while lists only allow slow sequential access.
    * Therefore we need a different function to sort all elements that does
    * not need random access iterators.
    *
    * comp       [Optional] A comparison function (see above)
    *
    * Note that sort() is specific for the list and is implemented as a
    * member function of list<>. This is much more object orientated.
    */
    l.sort(comp);
    cout << "List: ";
    for (lIt = l.begin(); lIt != l.end(); lIt++) {
        cout << *lIt << " ";
    }
    cout << endl;
    /* Output:
        * Vector: 12 5 1
        * List: 12 5 1
        */
    return 0;
}
```