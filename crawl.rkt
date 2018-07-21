;; 数据来源 https://so.gushiwen.org/mingju/
#lang racket
(require html-parsing
         net/url
         sxml
         json)

(struct mingju (contents source) #:prefab)

(define (crawl url)
  (define-values (status headers html)
    (http-sendrecv/url
     (string->url
      "https://so.gushiwen.org/mingju/default.aspx?p=1&c=&t=")))
  (define xexp (html->xexp html))
  (let loop ([items ((sxpath "(//div[@class='left']//div[@class='cont'])//a/text()") xexp)]
             [result empty])
    (if (empty? items)
        result
        (loop (cddr items)
              (cons (mingju (first items) (second items)) result)))))

(define mjs
  (apply
   append
   (for/list ([i (in-range 1 201)])
     (define url (format "https://so.gushiwen.org/mingju/default.aspx?p=~a&c=&t=" i))
     (printf "Crawling ~a\n" url)
     (crawl url))))

(with-output-to-file "mingju.json"
  (lambda ()
    (write-json
     (for/list ([mj (in-list mjs)])
       (hasheq 'contents (mingju-contents mj)
               'source (mingju-source mj))))))
