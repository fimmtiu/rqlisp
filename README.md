# Rqlisp

This is a little Lisp interpreter which I threw together over the course of about 1.5 working days. I didn't get as far as I'd like, but it's still not bad. The only data types at this point are strings, integers, functions, and macros. (No quasiquotation yet, though.)

```lisp
(defn print-number-range (n max)
  (if (> n max)
    nil
    (do
      (print n)
      (print-number-range (+ n 1) max)))))

;; Prints the integers between 3 and 10, inclusive
(print-number-range 3 10)
```

## Usage

With code in files:
```
$ ruby -Ilib exe/rqlisp code.l
```

With code on the command line:
```
$ ruby -Ilib exe/rqlisp -c '(print "hello, world!")'
```

To drop into a pry debugger, use `(debug)` in your code.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Todo

* Go back and fix up the `=`, `<`, etc. builtins to use rest args
* Move specs out of Runtime into the individual data types' specs
* Rip most of the crap out of DataType
* Way more error checking
* Add new data types (floats, symbols, etc.)
* Lots, lots, lots more stuff.
