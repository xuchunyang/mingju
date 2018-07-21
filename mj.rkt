#lang racket
(require json
         web-server/http
         web-server/managers/none)

(provide interface-version manager start)

(define interface-version 'v2)

(define manager
  (create-none-manager
   (lambda (req)
     (response/xexpr
      `(html (head (title "No Continuations Here!"))
             (body (h1 "No Continuations Here!")))))))

(define mingju.json
  (if (file-exists? "mingju.json")
      ;; local test
      "mingju.json"
      ;; Ubuntu VPS
      ;; FIXME: Don't hard-code, maybe use default-configuration-table-path ?)
      "/var/www/xuchunyang.me/racket/mingju.json"))

(define items
  (with-input-from-file mingju.json
    read-json))

(define (build-json-response)
  (response
   200
   #"OK"
   (current-seconds)
   #"application/json"
   empty
   (lambda (op)
     (define item (list-ref items (random 0 (length items))))
     (write-json item op))))

(define (build-plain-response)
  (response
   200
   #"OK"
   (current-seconds)
   #"text/plain; charset=utf-8"
   empty
   (lambda (op)
     (define item (list-ref items (random 0 (length items))))
     (write-string
      (string-append (hash-ref item 'contents) "\n"
                     "\t\t-- " (hash-ref item 'source) "\n")
      op))))

(define (start req)
  (define bindings (request-bindings/raw req))
  (define (get-value id bindings)
    (match (bindings-assq id bindings)
      [(? binding:form? b)
       (bytes->string/utf-8 (binding:form-value b))]
      [_ #f]))
  (define fmt (get-value #"format" bindings))
  (if (equal? fmt "json")
      (build-json-response)
      (build-plain-response)))

;; local test
(module+ main
  (require web-server/servlet-env)
  (serve/servlet start))
