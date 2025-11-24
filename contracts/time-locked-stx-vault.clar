;; ---------------------------------------------------------
;; time-locked-stx-vault.clar
;; A vault that locks STX until a specified unlock time.
;; ---------------------------------------------------------

(define-data-var deposit-counter uint u0)

(define-map deposits
  { id: uint }
  {
    owner: principal,
    amount: uint,
    unlock-height: uint,
    claimed: bool
  }
)

;; ---------------------------------------------------------
;; PUBLIC FUNCTIONS
;; ---------------------------------------------------------

;; Deposit STX into the time-locked vault
(define-public (create-deposit (amount uint) (unlock-height uint))
  (begin
    (if (<= amount u0)
        (err u100)                   ;; Invalid deposit amount
        (if (<= unlock-height burn-block-height)
            (err u101)               ;; Unlock time must be in the future
            (let (
                  (new-id (+ (var-get deposit-counter) u1))
                )
              (begin
                (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

                (map-set deposits
                  { id: new-id }
                  {
                    owner: tx-sender,
                    amount: amount,
                    unlock-height: unlock-height,
                    claimed: false
                  }
                )

                (var-set deposit-counter new-id)
                (ok new-id)
              )
            )
        )
    )))

;; Claim locked STX after unlock time
(define-public (claim-deposit (deposit-id uint))
  (let (
        (deposit (map-get? deposits { id: deposit-id }))
       )
    (match deposit
      entry
        (if (not (is-eq tx-sender (get owner entry)))
            (err u102)               ;; Only owner can claim
            (if (get claimed entry)
                (err u103)           ;; Already claimed
                (if (> (get unlock-height entry) burn-block-height)
                    (err u104)       ;; Not yet unlocked
                    (begin
                      (try! (stx-transfer? (get amount entry)
                                           (as-contract tx-sender)
                                           (get owner entry)))

                      (map-set deposits
                        { id: deposit-id }
                        {
                          owner: (get owner entry),
                          amount: (get amount entry),
                          unlock-height: (get unlock-height entry),
                          claimed: true
                        }
                      )

                      (ok true)
                    )
                )
            )
        )
      (err u105)                     ;; Deposit not found
    )))
